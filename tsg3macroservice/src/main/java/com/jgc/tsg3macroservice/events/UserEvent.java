package com.jgc.tsg3macroservice.events;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserEvent {

    private String id;
    private String type;
    private String payload;
    private long timestamp;
}
