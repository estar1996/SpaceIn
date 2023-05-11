package com.example.backend.service;

import com.amazonaws.services.s3.AmazonS3Client;
import com.example.backend.repository.PostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class S3Service {

    private final PostRepository postRepository;

    @Value("${SERVER_ENV:local}")
    private String environment;

    @Value("${FILE_DIR:/src/main/resources/static/files/}")
    private String basicDir;

    private String fileDir;

    private final AmazonS3Client amazonS3Client;


}
