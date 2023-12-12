# jumpload

establish a second loading order specifically for messing with internals

### Caveat
the shell is actually running twice, we just immediately kill the root shell. startup applications loading after `jumpload` are manually called during  the init process.
