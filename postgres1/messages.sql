CREATE TABLE messages(
    message_id uuid PRIMARY KEY,
    user_id uuid NOT NULL,
    message text NOT NULL,
    sent timestamptz NOT NULL
);

-- this allows update and delete events to contain the "before" field
ALTER TABLE messages REPLICA IDENTITY FULL;

INSERT INTO messages (message_id,user_id,message,sent) VALUES ('7EDA6993-2FAE-4104-9565-DD509A172C7D','8f232ed5-4cf6-4606-b539-f608473e5949','Hello my name is Alice',NOW());
