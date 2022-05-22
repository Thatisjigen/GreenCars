package com.webservice.rest;

import org.unicampania.greencars.TicketConfirmRequest;
import java.io.IOException;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Response;
import org.unicampania.greencars.Request;

@Path("/bookColumn")
public class BookingWebService {

    @Path("{a}/{b}/{c}/{d}")
    @GET
    @Produces("application/json")
    public Response GetMyJson(@PathParam("a") String date, @PathParam("b") String time, @PathParam("c") String duration,
            @PathParam("d") String id) throws IOException {

        TicketConfirmRequest request = new TicketConfirmRequest(date, time, duration, id);

        String result;
        result = (String) Request.GetResponce(request);
        return Response.status(200).entity(result).build();
    }

}
