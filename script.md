# Video script

[pirate island gameplay]
[gadget room gameplay]

Did you know 2023 is the year of Fortran in Gamedev? Now you know.

Hello everyone, today I'm going to take a look at the Fortran programming language.

Fortran is a general-purpose programming language, considered to be the first widely used high-level language. It was created in 1957 by John Backus at IBM. It's mainly used for numeric computations and scientific computing in areas such as weather prediction, fluid dynamics, physics and others. As I always do in this channel, I'm going to make a cool game with it.

There are 7 Fortran standards. From what I've read, everything before Fortran 90 is considered legacy, and Fortran 95 is the "stable" version, which I think is pretty much Fortran 90 but with a couple of extra things added.
Most people see Fortran as a really old and forgotten language, but in reality there are several standards released not too long ago, like 2003, 2008 and 2018; the next standard will be released sometime in 2023, so if new standards are getting released it means people are still using and supporting this language, I guess? Which is funny because you would think that this language is still used mostly because there are a lot of legacy codebases just like COBOL, but maybe there are new software being written in this language...

Anyway, this isn't something I usually show, but I wanted to show the steps I did to use this language.

So, first step is to download a compiler. I used gfortran, which is deveolped by the GNU Project, and it's what all the cool kids are using nowadays.

Let's take a look at a hello world in Fortran, taken from the Fortran website:

```fortran
program hello
  ! This is a comment line; it is ignored by the compiler
  print *, 'Hello, World!'
end program hello
```

My first question is, why is there an asterisk after print? Maybe is for formatting? After looking it up, is just to say to print to the "default file" which is the standard output.

Okay, looking at the `--help` command, compiling Fortran is similar to compile C code, just pass the output and input files.

Now, remember when I said that Fortran has several standards? My question is, what standard does this compiler use by default? If you say _"oh, if the file extension is "f90" then it must be inferred from there!"_, then I'm afraid you're wrong.

https://linux.die.net/man/1/gfortran

According to the manual: _"the default value for std is gnu, which specifies a superset of the Fortran 95 standard that includes all of the extensions supported by GNU Fortran"_
So yeah, it would be kind of cool if the `--help` command was a _tiny bit_ more descriptive.

https://stackoverflow.com/a/10627693

Anyway, this code compiles and runs correctly, buy why is there a space after the string? According to Jim Lewis at StackOverflow, basically is just a really, really old Fortran "feature."

https://fortran-lang.org/en/learn/quickstart/variables/

Moving on to the variables, there are 5 built-in data types: integer, real, complex, character and logical, which makes sense. So a program that declares variables looks like this:

```fortran
program variables
  implicit none

  integer :: amount
  real :: pi
  complex :: frequency
  character :: initial
  logical :: isOkay

end program variables
```

So it looks okay, but what is `implicit none`? According to the Fortran website, it tells the compiler _"all variables will be explicitly declared; without this statement variables will be implicitly typed according to the letter they begin with."_

That last part is really interesting...

After looking it up, it seems to be another of those REALLY OLD features, where:
- variables beginning with i to n are `integer`s
- everything else is `real`

**Wow.**

In modern times, everyone in the Fortran community agree that this is a really bad practice, but when you think about the point of this language was to be used by mathematicians and scientists, it _kind of_ makes sense when you are writing formulas it's common to use i, j, k... as integers, but I digress.

https://github.com/xeenypl/raylib.f90

Let's now look at how we can call C functions. I used bindings for raylib made by the user "xeenypl". It says "work in progress", but we can work out whatever is missing.

Looking at the C binding, it suprised me how clean and easy to understand it is.

The C `struct`s are `type`s in Fortran.
Apparently, there is no way to declare constants, so you just declare it as an integer and that's it.

Finally, things that don't return something are subroutines and those that do are functions. You just have to set the type of the parameters, the "intent" which is just to say to the compiler that the "in" parameter won't change, and the type of the output if there's any. And of course, bind to "C" and the name of the C function.

I really like the fact that there is no return, you just have to declare the "result" variable when declaring the function.

So with this, I made my first window in Fortran with this code.

And... it doesn't work. Something funny about the colors... raylib colors are defined as unsigned integers, but Fortran only has int8_t which is _signed_ integer that goes from -128 to 127, so when I pass 255 it is out of range. To fix this, the compiler suggest to pass an extra parameter `-fno-range-check` so the number out of range wrap around to values in range.

So with that, it compiles and runs! Except... the window title is strange.

https://stackoverflow.com/a/57384514
After a lot of googling, Fortran strings _"are not null terminated [like C strings,] it's up to the implementation to track their length."_
So basically, without the null terminator, C doesn't know where the strings ends. I have to manually append the null character to every string that I pass to a C function.
After that change, it finally works correctly!

Let's now look at the implementation of the game.

The implementation is based on an implementation made by RuolinZheng using Renpy. I also used a similar Python script that she used to generate beatmaps from any song.
The beatmaps are simply the number of seconds of each onset and the note they correspond. Basically, the Python script does the following:
- Detect the number of seconds of every onset in the song.
- Get the frequency of each note by using FFT.
- Use a clustering algorithm (KMeans) to group the frequencies into 4 "beats".

Could all of this be done in Fortran? Absolutely, but implementing all of these algorithms would take time and effort, so I decided to go for the easy route with Python.

Let's take a look at the implementation of the "beatmaps"

I wrapped the entire code in a module called "Map". Here, you can see the first thing I defined are the "types", which are kind of similar to C structs.

The "beat" type, which represents the notes of the song.

The "bar" type which are the 4 bars that contain the different notes. Note that the array that contains the beats doesn't have a dimension specified and it's "allocatable", which means we can allocate any number of beats we want. This will be important later when we're reading from the beatmap file.

And finally, the "message" type with the message showing the accuracy of the player hitting the note, and the "music_playing" type with contains all of the previous types, plus some timers and the song playing.
Also a texture with the arrows, and the "music_playing" type.

The word "contains" separates the declarations of the types with the definitions of the functions and subroutines. We don't actually need to declare these subroutines before the "contains", we just simply declare them.

There are three parts that I want to show how I implemented in this rhythm game:
- How to load the beatmap previously shown.
- How to "slide" the arrows through the bars according to the beatmap.
- How to check the accuracy of the note pressed.

To load the beatmap, I need to read the file generated by the Python script.

Now here's probably the most hacky part of the code.
First, I open the file with open().
Unit is an integer used to identify the file when reading and closing it.

"do" is an infinite loop, because we don't know the exact size of the file beforehand.
Here's a cool feature of Fortran that I haven't seen in any other language: you can read and store the contents of the file directly into variables. In any other language, I would have to read the whole line, split it and set the variables, but in Fortran all of that is done in a single line.

Now, for some reason, I could _not_ get Fortran to tell me when it reaches the end of the file, so when trying to read beyond the end of the file it crashes. Nothing I tried worked, so as a workaround I simply set the last note to -1 so when reading that value I just break from the loop. It's most likely something wrong in my code, but I couldn't for the life of me figure out what's wrong...

First I iterate through the whole file only to get the number of notes of this particular song. Remember when I said the array containing the notes don't have a specified size? Well, now we know the size, so we simply call `allocate` to set the size.
Now I have to `rewind` the file to read it from the beginning, and loop again to set the `beat` objects into the arrays, and finally close the file.
Maybe this is too overcomplicated, but yeah, it is what it is.

Now, sliding the notes across the screen and timing them accordingly to the song it's pretty simple. The notes have a predefined speed and we know the distance between the origin point and the spot. The math is simple: speed = distance/time, or in this case, distance = speed * time. The time is the difference between the "current time" and the oneset defined in the beatmap. As time passes, that difference gets smaller and so does the distance, and that's how the notes slide through the bars.
I have no idea how other rhythm games do it, but I think this implementation it's pretty clever.

Finally, detecting the accuracy of the notes pressed is also pretty simple.
We get the difference between the current time and the onset. Depending on the time difference when a key is pressed, we set the different messages.
There's a problem with these hardcoded values, since they depend on the speed of the notes. If the speed is different, these values no longer work. I realized this when I was recording this, sooo yeah ¯\\\_(ツ)\_/¯

That pretty much covers the most important parts of the implementation of this rhythm game. As always, the code is uploaded to Github.

Fortran is a nice language, with a couple of quirks here and there, but still, I had a good time developing in this language.

Thanks for watching!