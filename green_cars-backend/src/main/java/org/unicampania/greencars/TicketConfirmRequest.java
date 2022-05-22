package org.unicampania.greencars;

public class TicketConfirmRequest {

    String duration;
    String date;
    String time;
    String id;

    public TicketConfirmRequest(String date, String time, String duration, String id) {
        this.date = date;
        this.time = time;
        this.duration = duration;
        this.id = id;
    }

}
