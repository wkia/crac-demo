package com.example;

import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.context.ApplicationContextException;
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
        return "Hello from Spring Boot on AWS Lambda with CRaC! counter=" + counter;
    }

    @GetMapping("/checkpoint")
    void checkpoint() {
        System.out.println("Triggering JVM checkpoint/restore");
        try {
            org.crac.Core.checkpointRestore();
            System.out.println("Restored!!!");
        } catch (org.crac.CheckpointException e) {
            throw new ApplicationContextException("CRaC failed to checkpoint", e);
        } catch (org.crac.RestoreException e) {
            throw new ApplicationContextException("CRaC failed to restore", e);
        } catch (UnsupportedOperationException e) {
            throw new ApplicationContextException("CRaC checkpoint not supported", e);
        }
    }
}
