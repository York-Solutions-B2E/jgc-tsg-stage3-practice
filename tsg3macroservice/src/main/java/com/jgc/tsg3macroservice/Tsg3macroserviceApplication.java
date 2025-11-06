package com.jgc.tsg3macroservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.kafka.annotation.EnableKafka;

@SpringBootApplication
public class Tsg3macroserviceApplication {

	public static void main(String[] args) {
		SpringApplication.run(Tsg3macroserviceApplication.class, args);
	}

}
