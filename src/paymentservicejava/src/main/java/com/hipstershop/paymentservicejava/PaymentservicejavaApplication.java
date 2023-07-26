package com.hipstershop.paymentservicejava;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class PaymentservicejavaApplication {

	public static void main(String[] args) {
		SpringApplication.run(PaymentservicejavaApplication.class, args);
	}

}
