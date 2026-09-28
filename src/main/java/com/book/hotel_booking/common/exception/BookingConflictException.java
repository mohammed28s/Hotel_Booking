package com.book.hotel_booking.common.exception;





public class BookingConflictException extends RuntimeException {

    public BookingConflictException() {
    }
    public BookingConflictException(String message) {
        super(message);
    }
}
