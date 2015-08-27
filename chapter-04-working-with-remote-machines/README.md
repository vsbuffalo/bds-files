# Working with Remote Machines

This Github directory contains:

 - `.tmux.conf`: a friendly starter Tmux configuration.

## Tmux Configuration

This configuration unbinds Tmux's C-b keystroke, replacing it with C-a. C-a is
what GNU Screen uses, which is why this is a common change. I've decided to use
C-a here because this is what I, most other Tmux users, and many online
tutorials use, and would be easiest for readers to become acquainted with. The configuration file also adjusts colors and creates a helpful status bar.

## Some Security Details about SSH Forwarding

If you're worried about security, you might want to read this post on [SSH
Agent
Forwarding](http://heipei.github.io/2015/02/26/SSH-Agent-Forwarding-considered-harmful/)
(and [HackerNews comments](https://news.ycombinator.com/item?id=9425805)). From the SSH manual:

> Agent forwarding should be enabled with caution. Users with the ability to
> bypass file permissions on the remote host (for the agent's UNIX-domain socket)
> can access the local agent through the forwarded connection. An attacker cannot
> obtain key material from the agent, however they can perform operations on the
> keys that enable them to authenticate using the identities loaded into the
> agent.

While this is a possible concern, I (and many others) still use SSH forwarding
as taught in the book. But it's good to be aware of this as a possible issue.
