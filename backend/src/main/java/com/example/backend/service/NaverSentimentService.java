package com.example.backend.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.net.URL;
import java.util.Collections;

@Service
public class NaverSentimentService {
    private static final String URL = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze";

    private static final String CLIENT_ID = "lrmj5n6wjs";
    private static final String CLIENT_SECRET = "bHt3fJYGvOjdxroiV8pgW8APVGyLAXmhcRj4jLPt";

//    public ResponseEntity<String> analyzeSentiment(String text) {
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.APPLICATION_JSON);
//        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
//        headers.set("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
//        headers.set("X-NCP-APIGW-API-KEY", CLIENT_SECRET);
//
//        String body = "{\"content\": \"" + text + "\"}";
//
//        HttpEntity<String> entity = new HttpEntity<>(body, headers);
//        RestTemplate restTemplate = new RestTemplate();
////
////        try {
////            ResponseEntity<String> response = restTemplate.exchange(URL, HttpMethod.POST, entity, String.class);
////            return response;
////        } catch (Exception e) {
////            e.printStackTrace();
////            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
////        }
//        try {
//            ResponseEntity<String> response = restTemplate.exchange(URL, HttpMethod.POST, entity, String.class);
//            String sentimentResult = response.getBody();
//            String processedSentiment = processSentimentResult(sentimentResult);
//            return processedSentiment;
//        } catch (Exception e) {
//            e.printStackTrace();
//            return "";
//        }
//    }

    public ResponseEntity<String> analyzeSentiment(String text) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.set("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
        headers.set("X-NCP-APIGW-API-KEY", CLIENT_SECRET);

        String body = "{\"content\": \"" + text + "\"}";

        HttpEntity<String> entity = new HttpEntity<>(body, headers);
        RestTemplate restTemplate = new RestTemplate();

        try {
            ResponseEntity<String> response = restTemplate.exchange(URL, HttpMethod.POST, entity, String.class);
            String sentimentResult = response.getBody();
            String processedSentiment = processSentimentResult(sentimentResult);
            return ResponseEntity.ok(processedSentiment);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    private String processSentimentResult(String sentimentResult) {
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            JsonNode sentimentJson = objectMapper.readTree(sentimentResult);
            JsonNode document = sentimentJson.get("document");
            JsonNode confidence = document.get("confidence");
            double negativeConfidence = confidence.get("negative").asDouble();
            double positiveConfidence = confidence.get("positive").asDouble();
            double neutralConfidence = confidence.get("neutral").asDouble();
            String sentiment = document.get("sentiment").asText();

            // 신뢰도 값에 따라 감정 텍스트를 결정합니다.
            String sentimentText;
            if (sentiment.equals("negative")) {
                sentimentText = getSentimentText(negativeConfidence, "negative");
            } else if (sentiment.equals("positive")) {
                sentimentText = getSentimentText(positiveConfidence, "positive");
            } else {
                sentimentText = getSentimentText(neutralConfidence, "neutral");
            }

            return sentimentText;
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            return "";
        }
    }




    private String getSentimentText(double confidence, String sentiment) {
        if (sentiment.equals("negative")) {
            if (confidence >= 0.8) {
                return "최악";
            } else if (confidence >= 0.6) {
                return "불편";
            } else if (confidence >= 0.3) {
                return "예민";
            } else {
                return "부정적";
            }
        } else if (sentiment.equals("positive")) {
            if (confidence >= 0.8) {
                return "활활";
            } else if (confidence >= 0.6) {
                return "행복";
            } else if (confidence >= 0.3) {
                return "꽤 좋아";
            } else {
                return "긍정적";
            }
        } else if (sentiment.equals("neutral")) {
            if (confidence >= 0.8) {
                return "쏘쏘";
            } else if (confidence >= 0.6) {
                return "꽤 괜찮아";
            } else if (confidence >= 0.3) {
                return "나름 좋아";
            } else {
                return "중립적";
            }
        } else {
            return "알 수 없음";
        }
    }



}
