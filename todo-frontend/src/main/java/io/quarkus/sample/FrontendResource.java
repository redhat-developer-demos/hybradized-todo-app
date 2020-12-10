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

import org.eclipse.microprofile.rest.client.inject.RestClient;

@Path("/api")
public class FrontendResource {


    
    @RestClient
    public BackendService backendService;

    @OPTIONS
    public Response opt() {
        return backendService.opt();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Todo> getAll() {
        return backendService.getAll();
    }

    @GET
    @Path("/cloud")
    @Produces(MediaType.TEXT_PLAIN)
    public String getCloud() {
        return backendService.getCloud();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Path("/{id}")
    public Todo getOne(@PathParam("id") Long id) {
        return backendService.getOne(id);
    }

    @POST
    public Response create(Todo item) {
        return backendService.create(item);
    }

    @PATCH
    @Path("/{id}")
    public Response update(Todo todo, @PathParam("id") Long id) {
        return backendService.update(todo, id);
    }

    @DELETE
    public Response deleteCompleted() {
        return backendService.deleteCompleted();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteOne(@PathParam("id") Long id) {
        return backendService.deleteOne(id);
    }

}
