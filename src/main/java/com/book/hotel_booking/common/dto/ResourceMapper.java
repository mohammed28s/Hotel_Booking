package com.book.hotel_booking.common.dto;


import com.book.hotel_booking.resource.Resource;
import org.springframework.web.bind.annotation.Mapping;

@Mapper(componentModel = "spring")
public interface ResourceMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "status", ignore = true)
    Resource toEntity(ResourceRequest request);

    @Mapping(target = "categoryName", source = "category.name")
    @Mapping(target = "providerName", source = "provider.email")
    ResourceResponse toResponse(Resource resource);


}
