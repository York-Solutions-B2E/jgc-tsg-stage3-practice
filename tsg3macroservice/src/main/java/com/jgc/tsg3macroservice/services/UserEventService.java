package com.jgc.tsg3macroservice.services;

import com.jgc.tsg3macroservice.events.UserEvent;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Service
public class UserEventService {

    private KafkaTemplate<String, UserEvent> kafkaTemplate;
    
    @Value("${event.topic.name}")
    private String topicName;

    public UserEventService(KafkaTemplate<String, UserEvent> kafkaTemplate) {
        this.kafkaTemplate = kafkaTemplate;
    }

    public void publishEvent(UserEvent event) {
        kafkaTemplate.send(topicName, event.getId(), event);
    }
}
