package org.unicampania.greencars;

import static org.unicampania.greencars.DBdata.PASS;
import static org.unicampania.greencars.DBdata.URL;
import static org.unicampania.greencars.DBdata.USER;
import java.io.*;
import java.util.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class getList {

    private static boolean valid;
    private static int supportedpwr;
    private static int givenPWR;
    private static int finalSoCpercent;

    public static String GetChargingPoints(TicketRequest request)
            throws IOException, NoSuchElementException {
        int counter = 0;
        JSONArray ticket_list = new JSONArray();
        JSONObject ticket_element[] = new JSONObject[1200];
        PreparedStatement sql = null;
        String lat;
        String lon;
        String price;
        int finalSoC = 0;
        Car car = new Car(request.ac_kwh, request.dc_kwh);
        try {
            Class.forName("com.mysql.jdbc.Driver");

            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            if (request.green.equals("1")) {
                if (car.hasDC()) {
                    sql = conn.prepareStatement("SELECT * FROM columns WHERE 6371 * acos( cos( radians(?) ) * cos( radians( lat ) ) * cos( radians( ? ) - radians(lon) ) + sin( radians(?) ) * sin( radians( lat ) ) ) < ? AND green=1 ORDER BY pricedc");
                } //http://www.codecodex.com/wiki/Calculate_distance_between_two_points_on_a_globe#MySQL
                else {
                    sql = conn.prepareStatement("SELECT * FROM columns WHERE 6371 * acos( cos( radians(?) ) * cos( radians( lat ) ) * cos( radians( ? ) - radians(lon) ) + sin( radians(?) ) * sin( radians( lat ) ) ) < ? AND green=0 ORDER BY priceac");
                }
            } else {
                if (car.hasDC()) {
                    sql = conn.prepareStatement("SELECT * FROM columns WHERE 6371 * acos( cos( radians(?) ) * cos( radians( lat ) ) * cos( radians( ? ) - radians(lon) ) + sin( radians(?) ) * sin( radians( lat ) ) ) < ? ORDER BY pricedc");
                } else {
                    sql = conn.prepareStatement("SELECT * FROM columns WHERE 6371 * acos( cos( radians(?) ) * cos( radians( lat ) ) * cos( radians( ? ) - radians(lon) ) + sin( radians(?) ) * sin( radians( lat ) ) ) < ? ORDER BY priceac");
                }
            }
            sql.setString(1, request.lat);
            sql.setString(2, request.lon);
            sql.setString(3, request.lat);
            sql.setString(4, request.radius);
            ResultSet candidate = sql.executeQuery();
            int steps = Integer.parseInt(request.duration) / 15;
            
            while (candidate.next()) {
                valid = true;
                for (int step = 0; step < steps; step++) {
                    //iterate to check if is not booked
                    {
                        sql = conn.prepareStatement("SELECT * FROM booked_columns WHERE DATE=? and TIME= ? and id=?");
                        String date = (request.date + " " + request.time);
                        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                        LocalDateTime dateTime = LocalDateTime.parse(date, formatter);
                        dateTime = dateTime.plusMinutes(step * 15);
                        String newDateUnsplit = dateTime.toString();
                        String[] newDateTime = newDateUnsplit.split("T");
                        sql.setString(1, newDateTime[0]);
                        sql.setString(2, newDateTime[1]);
                        sql.setString(3, candidate.getString("id"));
                        ResultSet booked = sql.executeQuery();
                        if (booked.next()) {//if is already booked bail
                            valid = false;
                        }
                    }
                }
                if (valid) {//thecolum is free
                    if (car.hasDC()) {//DC has an higher priority
                        supportedpwr = 0;
                        if (Integer.parseInt(candidate.getString("dcpwr"))>Integer.parseInt(request.dc_kwh))
                            supportedpwr=Integer.parseInt(request.dc_kwh);
                        else 
                            supportedpwr=Integer.parseInt(candidate.getString("dcpwr"));
                        givenPWR = (supportedpwr/4)*steps;//power is per hour, store the power erogated
                        finalSoC = givenPWR + Integer.parseInt(request.starting_kwh);
                        if (finalSoC>Integer.parseInt(request.maxKwh))
                            finalSoC=Integer.parseInt(request.maxKwh);
                        if (finalSoC >= (Integer.parseInt(request.minSoC_kwh))) {
                            counter++;
                            ticket_element[counter] = new JSONObject();
                            lat = candidate.getString("lat");
                            lon = candidate.getString("lon");
                            price = Integer.toString(steps * Integer.parseInt(candidate.getString("pricedc")));
                            String chargingString = "";
                            int chargingState[]= new int[steps];
                            int chargedKwh=Integer.parseInt(request.starting_kwh);
                            for (int step = 0; step < steps; step++) {
                                chargedKwh=chargedKwh+supportedpwr/4;
                                chargingState[step]=(chargedKwh*100)/Integer.parseInt(request.maxKwh);
                                chargingState[step]=chargingState[step]>=100 ? 100 : chargingState[step]; //coherce to 100
                                if (step>0){
                                    chargingString=chargingString+"T"+Integer.toString(chargingState[step]);
                                } else {
                                    int startingPWR=(Integer.parseInt(request.starting_kwh)*100)/Integer.parseInt(request.maxKwh);
                                    chargingString=startingPWR+"T"+Integer.toString(chargingState[step]);
                                }
                            }
                            finalSoCpercent=chargingState[steps-1];
                            ticket_element[counter].put("lat", lat);
                            ticket_element[counter].put("lon", lon);
                            ticket_element[counter].put("price", price);
                            ticket_element[counter].put("finalSoC", finalSoCpercent);
                            ticket_element[counter].put("id", candidate.getString("id"));
                            ticket_element[counter].put("address", candidate.getString("address"));
                            ticket_element[counter].put("chargingState",chargingString);
                            ticket_list.add(ticket_element[counter]);
                        }
                    } else {//useAC
                        supportedpwr = 0;
                        if (Integer.parseInt(candidate.getString("acpwr"))>Integer.parseInt(request.ac_kwh))
                            supportedpwr=Integer.parseInt(request.ac_kwh);
                        else 
                            supportedpwr=Integer.parseInt(candidate.getString("acpwr"));
                        givenPWR = (supportedpwr/4)*steps;//power is per hour
                        finalSoC = givenPWR + Integer.parseInt(request.starting_kwh);
                        if (finalSoC>Integer.parseInt(request.maxKwh))
                            finalSoC=Integer.parseInt(request.maxKwh);
                        if (finalSoC >= (Integer.parseInt(request.minSoC_kwh))) {
                            counter++;
                            ticket_element[counter] = new JSONObject();
                            lat = candidate.getString("lat");
                            lon = candidate.getString("lon");
                            price = Integer.toString(steps * Integer.parseInt(candidate.getString("priceac")));
                            String chargingString = "";
                            int chargingState[]= new int[steps];
                            int chargedKwh=Integer.parseInt(request.starting_kwh);
                            for (int step = 0; step < steps; step++) {
                                chargedKwh=chargedKwh+supportedpwr/4;
                                chargingState[step]=(chargedKwh*100)/Integer.parseInt(request.maxKwh);
                                chargingState[step]=chargingState[step]>=100 ? 100 : chargingState[step]; //coherce to 100
                                if (step>0){
                                    chargingString=chargingString+"T"+Integer.toString(chargingState[step]);
                                } else {
                                    int startingPWR=(Integer.parseInt(request.starting_kwh)*100)/Integer.parseInt(request.maxKwh);
                                    chargingString=startingPWR+"T"+Integer.toString(chargingState[step]);
                                }
                            }
                            finalSoCpercent=chargingState[steps-1];
                            ticket_element[counter].put("lat", lat);
                            ticket_element[counter].put("lon", lon);
                            ticket_element[counter].put("price", price);
                            ticket_element[counter].put("finalSoC", finalSoCpercent);
                            ticket_element[counter].put("id", candidate.getString("id"));
                            ticket_element[counter].put("address", candidate.getString("address"));
                            ticket_element[counter].put("chargingState",chargingString);
                            ticket_list.add(ticket_element[counter]);
                        }
                    }
                }
            }
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
            return "SQL exception";
        }
        String result = ticket_list.toString();
        if (counter != 0) {
            return result;
        } else {
            return "No column available";
        }
    }
}
