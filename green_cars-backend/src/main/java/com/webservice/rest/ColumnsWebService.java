package com.webservice.rest;

import java.io.IOException;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import org.unicampania.greencars.getList;
import org.unicampania.greencars.TicketRequest;

@Path("/searchColumn")
public class ColumnsWebService {

    @Path("{a}/{b}/{r}/{c}/{d}/{e}/{f}/{g}/{h}/{i}/{l}/{m}")
    @GET
    @Produces("application/json")
    public Response GetMyJson(@PathParam("a") String lon, @PathParam("b") String lat, @PathParam("r") String radius, @PathParam("c") String green,
            @PathParam("d") String starting_kwh, @PathParam("e") String ac_kwh, @PathParam("f") String dc_kwh,
            @PathParam("g") String date, @PathParam("h") String time, @PathParam("i") String duration,
            @PathParam("l") String minSoC_kwh, @PathParam("m") String reqSoC_kwh) throws IOException {

        TicketRequest ticket = new TicketRequest(lon, lat, green, starting_kwh, ac_kwh, dc_kwh, date, time, duration, minSoC_kwh, reqSoC_kwh, radius);
        String result;
        result = getList.GetChargingPoints(ticket);
        return Response.status(200).entity(result).build();
    }

}

//lon/lat/radius/green/starting_kwh/ac_kwh/dc_kwh/date/time/duration/minSoC_kwh/reqSoC_kwh
//E.g: http://localhost:8888/green_cars-1.0-SNAPSHOT/ws/searchColumn with params:
//14.324226/41.072692/2/0/1/1/1/2022-11-11/10:10/90/20/10/
