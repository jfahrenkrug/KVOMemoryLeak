KVOMemoryLeak
=============

This small project only serves to demonstrate why you should never override `didChangeValueForKey:`. Or if you do, make sure you always call `super`. Because if you don't your object will never get dealloced.

You can see this in 2 easy steps:

1. Run the app as-is. In the overridden `didChangeValueForKey:` method in `SPWKViewController` `super` is called right in the first line. Everything is fine. The `SPWKThing` instance gets dealloced and the output is:

    ```
    initing SPWKThing
    Registering KVO, and things is (null)
    observeValueForKeyPath: things have changed!
    didChangeValueForKey: things have changed!
    SPWKThing dealloc
    Unregistering KVO
    ```
    
2. Open `SPWKViewController` and comment out the line `[super didChangeValueForKey:key];` in `didChangeValueForKey:` and run it again. Now you have a memory leak and the `SPWKThing` instance never gets dealloced. The output is:

    ```
    initing SPWKThing
    Registering KVO, and things is (null)
    didChangeValueForKey: things have changed!
    ```
    
Although the [Apple Documentation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Protocols/NSKeyValueObserving_Protocol/Reference/Reference.html#//apple_ref/occ/instm/NSObject/didChangeValueForKey:) does not explicitly forbid it, it seems to be a Very Bad Idea(tm) to override `didChangeValueForKey:`, at least when you don't call `super`.    
