package org.unicampania.greencars;

import static org.unicampania.greencars.DBdata.PASS;
import static org.unicampania.greencars.DBdata.URL;
import static org.unicampania.greencars.DBdata.USER;
import java.io.*;
import java.util.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Request {

    private static boolean valid;
    private static String responce;
    private static int bookedSuccessfully;

    public static String GetResponce(TicketConfirmRequest request)
            throws IOException, NoSuchElementException {

        try {
            Class.forName("com.mysql.jdbc.Driver");
            PreparedStatement sql;
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            ResultSet booked = null;
            int steps = Integer.parseInt(request.duration) / 15;
            valid = true;
            for (int step = 0; step < steps; step++) {
                //iterate to check if is not booked
                {
                    sql = conn.prepareStatement("SELECT * FROM booked_columns WHERE DATE=? and TIME=? and id=?");
                    String date = (request.date + " " + request.time);
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    LocalDateTime dateTime = LocalDateTime.parse(date, formatter);
                    dateTime = dateTime.plusMinutes(step * 15);
                    String newDateUnsplit = dateTime.toString();
                    String[] newDateTime = newDateUnsplit.split("T");
                    sql.setString(1, newDateTime[0]);
                    sql.setString(2, newDateTime[1]);
                    sql.setString(3, request.id);
                    booked = sql.executeQuery();
                    if (booked.next()) {
                        valid = false;
                    }
                }
            }
            if (valid) {//thecolum is still free
                for (int step = 0; step < (Integer.parseInt(request.duration) / 15); step++) {
                    sql = conn.prepareStatement("INSERT INTO booked_columns (id, date,time) VALUES (?,?,?)");
                    String date = (request.date + " " + request.time);
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    LocalDateTime dateTime = LocalDateTime.parse(date, formatter);
                    dateTime = dateTime.plusMinutes(step * 15);
                    String newDateUnsplit = dateTime.toString();
                    String[] newDateTime = newDateUnsplit.split("T");
                    sql.setString(1, request.id);
                    sql.setString(2, newDateTime[0]);
                    sql.setString(3, newDateTime[1]);
                    bookedSuccessfully = sql.executeUpdate();
                    if (bookedSuccessfully > 0) {//we aren't handling concurrency by now, should be done tho
                        responce = "ok";
                    } else {
                        responce = "abort";
                    }
                }
            } else {
                responce = "NotFree";
            }
            conn.close();
            return responce;
        } catch (ClassNotFoundException | SQLException e) {
            String result = "DB ERROR \n\n";
            return result;
        }
    }
}
