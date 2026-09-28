package com.book.hotel_booking.resource;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.UUID;


@Repository
public interface ResourceRepository extends JpaRepository<Resource, UUID>,
        JpaSpecificationExecutor<Resource> {
    // JpaSpecificationExecutor gives us dynamic filtering (Phase 3 search/filter)
   // without hand-writing a query per filter combination.

}
