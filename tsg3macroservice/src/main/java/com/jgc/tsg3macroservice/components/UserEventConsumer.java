package com.jgc.tsg3macroservice.components;

import com.jgc.tsg3macroservice.events.UserEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Component;

@Component
public class UserEventConsumer {

    private static final Logger logger = LoggerFactory.getLogger(UserEventConsumer.class);

    @KafkaListener(
                   topics = "${event.topic.name}",
                   containerFactory = "kafkaListenerContainerFactory",
                   groupId = "${spring.kafka.consumer.group-id}"
                   )
    public void receiveEvent(
                             @Header(KafkaHeaders.RECEIVED_PARTITION) int partition,
                             @Header(KafkaHeaders.RECEIVED_TIMESTAMP) long timestamp,
                             @Header(KafkaHeaders.OFFSET) long offset,
                             UserEvent event
                             ) {
        logger.info("Received event: partition={}, timestamp={}, offset={}", 
            partition, timestamp, offset);
        logger.debug("Event payload: {}", event);
        
        try {
            processEvent(event);
        } catch (Exception e) {
            logger.error("Error processing event: {}", event.getId(), e);
            throw e; // Allow Kafka to handle retry logic
        }
    }

    private void processEvent(UserEvent event) {
        // Implement business logic here
        logger.info("Successfully processed event: {}", event.getId());
    }
}
