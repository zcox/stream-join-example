#!/bin/bash

PGPASSWORD=postgres psql -h localhost -d postgres -U postgres -f init.sql
