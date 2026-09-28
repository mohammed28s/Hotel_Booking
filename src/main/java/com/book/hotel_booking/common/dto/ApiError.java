package com.book.hotel_booking.common.dto;


import java.time.Instant;

public record ApiError(String error, String message, Instant timestamp) {
}
