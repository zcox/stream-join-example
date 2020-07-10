CREATE TABLE users(
    user_id uuid PRIMARY KEY, 
    name text NOT NULL
);

-- this allows update and delete events to contain the "before" field
ALTER TABLE users REPLICA IDENTITY FULL;

INSERT INTO users (user_id,name) VALUES ('8F232ED5-4CF6-4606-B539-F608473E5949','Alice Adams'),('9861C821-E7B2-469D-9223-3FCE0EDF305F','Bob Billson');
