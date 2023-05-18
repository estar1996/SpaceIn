package com.example.backend.service;


import com.example.backend.domain.Region;
import com.example.backend.repository.RegionRepository;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpEntity;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;

@Service
public class NaverReverseGeocodingService {


    private static final String URL_TEMPLATE = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=%s,%s&orders=addr&output=json";

    private static final String CLIENT_ID = "lrmj5n6wjs";
    private static final String CLIENT_SECRET = "bHt3fJYGvOjdxroiV8pgW8APVGyLAXmhcRj4jLPt";

    @Autowired
    private RegionRepository regionRepository;

    public String getReverseGeocode(double latitude, double longitude) {
        String url = String.format(URL_TEMPLATE, longitude, latitude);

        HttpHeaders headers = new HttpHeaders();
        headers.set("X-NCP-APIGW-API-KEY-ID", CLIENT_ID);
        headers.set("X-NCP-APIGW-API-KEY", CLIENT_SECRET);
        HttpEntity<String> entity = new HttpEntity<>("parameters", headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, entity, String.class);

        if (response.getStatusCode() == HttpStatus.OK) {
            String jsonResponse = response.getBody();
            ObjectMapper mapper = new ObjectMapper();
            try {
                JsonNode rootNode = mapper.readTree(jsonResponse);
                JsonNode resultsNode = rootNode.path("results").get(0);
                String area1Name = resultsNode.path("region").path("area1").path("alias").asText();
                String area2Name = resultsNode.path("region").path("area2").path("name").asText();
                if (area1Name.isEmpty() || area2Name.isEmpty()) {
                    return null;
                } else {
                    String regionName = area1Name + " " + area2Name;
                    Region region = regionRepository.findByRegionName(regionName);
                    if (region == null) {
                        region = new Region();
                        region.setRegionName(regionName);
                        regionRepository.save(region);
                    }
                    return region.getRegionName();
                }
            } catch (IOException e) {
                throw new RuntimeException("Failed to parse JSON response:" + e.getMessage());
            }
        } else {
            throw new RuntimeException("Failed to get reverse geocode:" + response.getStatusCode());
        }
    }
}