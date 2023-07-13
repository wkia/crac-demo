package com.example;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class App {
    public static void main(String[] args) {
        System.out.println("Hello World!");
        SpringApplication.run(App.class, args);
    }
}

@RestController
class AppController {
    private int counter = 0;

    @GetMapping("/")
    public String hello() {
        ++counter;
        return "Hello from Spring Boot with CRaC! counter=" + counter;
    }
}
