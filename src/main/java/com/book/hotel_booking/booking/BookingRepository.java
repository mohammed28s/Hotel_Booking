package com.book.hotel_booking.booking;


import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface BookingRepository extends JpaRepository<Booking, UUID> {

    List<Booking> findByCustomerId(UUID customerId);
    List<Booking> findByResourceIdIn(List<UUID> resourceIds);


}
