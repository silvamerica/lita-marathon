# lita-marathon

Interact with the Marathon API for your Mesos cluster

## Installation

Add lita-marathon to your Lita instance's Gemfile:

``` ruby
gem "lita-marathon"
```

## Configuration

### Required Configuration

``` ruby
config.handlers.marathon.url = "http://example.com"
```

## Usage

```
m(arathon) list <filter> # List apps
m(arathon) count <filter> # Show instance counts
m(arathon) (force-)restart <filter> # Restart apps
m(arathon) (force-)suspend <filter> # Suspend apps
m(arathon) (force-)scale <filter> <instances> # Scale apps
```
