package io.quarkus.sample;

import java.util.List;

import javax.ws.rs.DELETE;
import javax.ws.rs.GET;
import javax.ws.rs.OPTIONS;
import javax.ws.rs.PATCH;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.eclipse.microprofile.rest.client.inject.RegisterRestClient;

@Path("/api")
@RegisterRestClient
public interface BackendService {
    
    @OPTIONS
    public Response opt();

    @GET
    @Path("/cloud")
    @Produces(MediaType.TEXT_PLAIN)
    public String getCloud();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Todo> getAll();

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/{id}")
    public Todo getOne(@PathParam("id") Long id);

    @POST
    public Response create(Todo item);

    @PATCH
    @Path("/{id}")
    public Response update(Todo todo, @PathParam("id") Long id);

    @DELETE
    public Response deleteCompleted();

    @DELETE
    @Path("/{id}")
    public Response deleteOne(@PathParam("id") Long id);

}
