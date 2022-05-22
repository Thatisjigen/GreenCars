package org.unicampania.greencars;

public class Car {

    int ac_kwh;
    int dc_kwh;

    Car(String ac_kwh, String dc_kwh) {
        this.ac_kwh = Integer.parseInt(ac_kwh);
        this.dc_kwh = Integer.parseInt(dc_kwh);
    }

    boolean hasDC() {
        return dc_kwh > 0;
    }
}
