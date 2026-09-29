package com.book.hotel_booking.common.dto;


import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

public record ResourceRequest(
        @NotBlank String name,
        String description,
        @NotBlank String location,
        @NotBlank UUID categoryId,
        @NotNull @DecimalMin("0.01") BigDecimal pricePerHour,
        @Min(1) Integer capacity
        ) {}
