
# Swift-IceCream
Welcome to Swift-IceCream!

Swift-IceCream is a logging and debugging tool for Swift projects, similar to Python's [IceCream](https://github.com/gruns/icecream.) It allows you to easily log and print messages, variables, and expressions during the development process, making it easier to track and debug your code.


## Hands-on

### Basic usage
```swift
 IceCream(category:"Category 1")
 ic.ic("Message 1")
```
Output:
```
 IC [Teste] |Message 1
```

Turning off all IceCream prints:
```
IceCream.priting = false
```

### Specifying logged info
Now, I want to print also the function wich called my code as well as the line and column.

```swift
 IceCream(category:"Category 1",
    logInfo:[.function,.lineAndColumn])

 ic.ic("Message 1")
```
Output:
```
IC [Category 1] .body {ln:26 cl:26} |Message 1
```

\
The order of the parameters alters the final result. 
`[.lineAndColumn, .function]` will result in:
```
IC [Category 1] {ln:26 cl:26} .body |Message 1
```
There are 4 parameters described in the `ICLogInfoConfiguration` enum:
- `date`
- `file`
- `lineAndColumn`
- `function`

### Changing parameters on the fly
You can also change the parameters on the fly.
```swift
 ic.ic("Message2", info: .date)
```
Output:
```
IC [Category 1] (14:34:38.951) |Message2
```

### Fast priting
One of the advantages of using IceCream is to print using only the `ic` command. You can do this by assign a varible to the default ic function:
```swift
 var ic = IceCream.asFunction()
 ic("Fast Print")
```
Output:
```
ic | Fast Print
```

### log level
You can also specify log levels to your printing messages.

```swift
IceCream(category:"Category 1",logInfo:[.lineAndColumn,.function])
ic.debug("Bug"))
```
Output:
```
<DEBUG>IC [Category 1] {ln:26 cl:29} .body |Bug
```

All log level used are described [here](https://developer.apple.com/documentation/os/logging/generating_log_messages_from_your_code).

### Setting the log level
Lets print only the ERRO flag

```swift
 IceCream.logLevel = .ERROR
 ic.debug("Bug")
 ic.error("ERROR")
```
Output:
```
<ERROR>IC [Category 1] {ln:28 cl:29} .body |ERROR
```
The debug print is ignored as expected

### Setting the log level by environment variables
W.I.P.



## Install

Use the Swift Package Manager 

    
## Contributions

Contributions are always welcome! Look at the issues or create a new one


## Authors

- [@MaiaJP](https://github.com/Maia-jp)

