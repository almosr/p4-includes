# P4 Includes

Include file framework for developing programs for Commodore Plus/4 platform in assembly using KickAssembler.

## Introduction

The motivation for creating this framework was to gather a comprehensive and flexible set of tools.
On one side using these include files might help with simplifying your code structure and make it more understandable.
On the other side provided set of functions and macros make life easier by implementing certain features ready to be
used in almost any codebase.

The obvious downside of any framework that it needs some effort to be invested into learning how it works and what
it is capable of. With this chore the provided documentation and example programs might help.

To someone who is coding for this platform for a long time this package might feel like an overkill, they know the TED
registers by heart for example. Luckily, it is not necessary to make use of every aspect of the includes, it is possible
to pick only what makes sense to you and what helps to code easier.

## How to use it

First of all, you need some knowledge of the MOS 65xx/75xx/85xx assembly. The examples might not be helpful in this
aspect, the goal was to demonstrate the framework instead of giving you an assembly or OS tutorial. How much knowledge
is needed actually that could be complicated to define, give it a try if you feel experienced enough.

The only required tool for the framework is [KickAssembler](http://theweb.dk/KickAssembler), the format of the source
code and certain functionality is depending on this assembler. I would also recommend learning how KickAssembler is
working, since you need to use it with this framework. 

If you don't want to copy the include files into your project (which would be my recommendation), then you can
specify the root `includes` folder to KickAssembler as a library directory using the `-libdir` command line option.
This way you can replace the complete folder when a new version is available and also possible to keep the framework
directory in a global path somewhere and use it in all your projects.

When you want to include a file then use the `#import` directive in your source code and specify the path of the file
starting from the `includes` root folder. See the examples regarding how this could be solved easily.

The source code of the includes are divided into individual files that are dedicated to one specific topic. Each file
can be used in isolation, when other files are required then those will be referenced by the included file.

None of the files would add any code to the output without calling its macros explicitly, so no need to worry about
the possible increase of the binary output. While each function, macro and constant are named uniquely, there is no
guarantee that none of them would collide with some other framework or existing code.

The directories in the `include` folder are named according to their purpose. The only directory that is not useful on
its own is the one called `internal`, that contains files which implement certain internal behaviour and not meant to
be included directly.

Under the `includes` directory each directory is dedicated to the following purpose:

* `gfx` - graphics-related functions and macros that are manipulating data for visual effects.
* `hardware` - various functions, macros and constants related to the machine's hardware directly or indirectly.
* `kickass` - KickAssembler-related functions, macros and constants, these are extending the assembler-provided
  functionality.
* `std_lib` - standard library of generic functions, all sorts of helper code to make the source code concise and
  easier to understand or to avoid code repetitions.
* `system` - various functions, macros and definitions that are related to the operating system of the platform.

## Examples

In the `examples` directory you can find some sources that demonstrate various functionality from the framework.
Complexity of the examples vary, some are extremely basic, others are more robust.

Examples can be built using the included `make_and_run.bat` on Windows, or an equivalent script on Linux/Unix-like
systems. The batch file expects another batch file in the path named `kickass` that is capable of running KickAssembler
from command line and forwards all parameters to the tool.

## Versioning

While new releases of the framework will be meant to be backward compatible with previous releases, new functionality
will only be available starting from specific versions of the framework.

Versioning follows the [Semantic versioning](https://semver.org) principles, please have a look at the link for more
details if you are not familiar with the concepts.

When your code is relying on a specific version then I would recommend using the validation functions included in the
`version.asm` file.

## How to extract documentation

### Required tools

* Preprocessing Python script that turns KickAssembler assembly sources into loosely C formatted for Doxygen processing.
  Get it from: [Github](https://github.com/intoinside/KickAssemblerToDoxygen).
* Doxygen documentation generation tool.
  Get it from: [Doxygen web page](https://www.doxygen.nl)

### Setup

1. Install Doxygen and make sure `bin` folder is accessible in the path.
2. Copy KickAssemblerToDoxygen Python script (or the whole repository) to the same parent folder where source folder is.
3. Change current directory to include source folder.
4. Run `generate_docs.bat`

Result will be dumped into a folder called `output` in the parent folder.

## License

This framework is open source under [MIT license](https://opensource.org/license/mit).
For further details please have a look at `LICENSE.md` file.

## Contact

If you have any comments, suggestions or bug reports then please get in touch with me via
[Plus/4 World](https://plus4world.powweb.com/members/Rachy) portal.