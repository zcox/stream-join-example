CREATE TABLE users(
    user_id uuid PRIMARY KEY, 
    name text NOT NULL
);

CREATE TABLE messages(
    message_id uuid PRIMARY KEY,
    user_id uuid NOT NULL REFERENCES users,
    message text NOT NULL,
    sent timestamptz NOT NULL
);

-- this allows update and delete events to contain the "before" field
ALTER TABLE users REPLICA IDENTITY FULL;
ALTER TABLE messages REPLICA IDENTITY FULL;

INSERT INTO users (user_id,name) VALUES ('8F232ED5-4CF6-4606-B539-F608473E5949','Alice Adams'),('9861C821-E7B2-469D-9223-3FCE0EDF305F','Bob Billson');

INSERT INTO messages (message_id,user_id,message,sent) VALUES ('7EDA6993-2FAE-4104-9565-DD509A172C7D','8f232ed5-4cf6-4606-b539-f608473e5949','Hello my name is Alice',NOW());
