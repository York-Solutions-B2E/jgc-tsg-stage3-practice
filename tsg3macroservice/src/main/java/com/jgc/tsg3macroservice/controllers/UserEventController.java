package com.jgc.tsg3macroservice.controllers;

import java.util.UUID;

import com.jgc.tsg3macroservice.events.UserEvent;
import com.jgc.tsg3macroservice.services.UserEventService;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/events")
public class UserEventController {

    private final UserEventService userEventService;

    public UserEventController(UserEventService userEventService) {
        this.userEventService = userEventService;
    }

    @PostMapping
    public ResponseEntity<Void> publishEvent(@RequestBody String payload) {
        UserEvent event = new UserEvent(
                                        UUID.randomUUID().toString(),
                                        "TEST_EVENT",
                                        payload,
                                        System.currentTimeMillis()
                                        );
        userEventService.publishEvent(event);
        return new ResponseEntity<>(HttpStatus.ACCEPTED);
    }
}
