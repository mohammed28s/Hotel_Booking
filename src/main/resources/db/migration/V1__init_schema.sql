CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "btree_gist";  -- needed for the EXCLUDE constraint below

CREATE TABLE users (
                       id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                       email VARCHAR(255) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role VARCHAR(20) NOT NULL,
                       enabled BOOLEAN NOT NULL DEFAULT TRUE,
                       created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
                            id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                            name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE resources (
                           id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                           provider_id UUID NOT NULL REFERENCES users(id),
                           category_id UUID NOT NULL REFERENCES categories(id),
                           name VARCHAR(255) NOT NULL,
                           description TEXT,
                           location VARCHAR(255) NOT NULL,
                           price_per_hour NUMERIC(10,2) NOT NULL,
                           capacity INT NOT NULL,
                           status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
                           created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE resource_images (
                                 id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                 resource_id UUID NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
                                 url VARCHAR(500) NOT NULL,
                                 is_primary BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE availability_slots (
                                    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                    resource_id UUID NOT NULL REFERENCES resources(id) ON DELETE CASCADE,
                                    day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
                                    start_time TIME NOT NULL,
                                    end_time TIME NOT NULL
);

CREATE TABLE bookings (
                          id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                          resource_id UUID NOT NULL REFERENCES resources(id),
                          customer_id UUID NOT NULL REFERENCES users(id),
                          start_time TIMESTAMPTZ NOT NULL,
                          end_time TIMESTAMPTZ NOT NULL,
                          status VARCHAR(20) NOT NULL DEFAULT 'CONFIRMED',
                          total_price NUMERIC(10,2) NOT NULL,
                          created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    -- THE key constraint: no two CONFIRMED bookings on the same resource
    -- may have overlapping [start_time, end_time) ranges.
    -- This is enforced by Postgres itself, at the DB level — not app code.
                          EXCLUDE USING gist (
        resource_id WITH =,
        tstzrange(start_time, end_time) WITH &&
    ) WHERE (status = 'CONFIRMED')
);

CREATE TABLE reviews (
                         id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                         resource_id UUID NOT NULL REFERENCES resources(id),
                         customer_id UUID NOT NULL REFERENCES users(id),
                         rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
                         comment TEXT,
                         created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE refresh_tokens (
                                id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
                                user_id UUID NOT NULL REFERENCES users(id),
                                token_hash VARCHAR(255) NOT NULL,
                                expires_at TIMESTAMPTZ NOT NULL,
                                revoked BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_resources_category ON resources(category_id);
CREATE INDEX idx_resources_provider ON resources(provider_id);
CREATE INDEX idx_bookings_resource ON bookings(resource_id);
CREATE INDEX idx_bookings_customer ON bookings(customer_id);