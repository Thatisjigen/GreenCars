package org.unicampania.greencars;

public class TicketRequest {

    String lat, lon, green, starting_kwh, ac_kwh, dc_kwh, date, time, duration;
    String minSoC_kwh, reqSoC_kwh;
    String radius;

    public TicketRequest(String lon, String lat, String green, String starting_kwh,
            String ac_kwh, String dc_kwh, String date, String time, String duration, String minSoC_kwh, String reqSoC_kwh, String radius) {
        this.lon = lon;
        this.lat = lat;
        this.green = green;
        this.starting_kwh = starting_kwh;
        this.ac_kwh = ac_kwh;
        this.dc_kwh = dc_kwh;
        this.date = date;
        this.time = time;
        this.duration = duration;
        this.minSoC_kwh = minSoC_kwh;
        this.reqSoC_kwh = reqSoC_kwh;
        this.radius = radius;
    }

}
