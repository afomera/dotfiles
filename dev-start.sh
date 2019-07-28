#!/bin/bash

brew services start postgresql
brew services start redis

# List them
brew services list
