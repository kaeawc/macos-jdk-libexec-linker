# MacOS JDK libexec linker

This repo contains some scripts and templates to make userland JDKs available to system tooling. Userland JDKs are installed through tools like `asdf` or `sdkman` and expose a much easier interface for developers to try out a wide variety of tools from a number of vendors, but since they do not write an entry in 

```bash
$ /usr/libexec/java_home -V

The operation couldn’t be completed. Unable to locate a Java Runtime.
Please visit http://www.java.com for information on installing Java.
```

Whereas if you use the Java installer from Oracle the JDK is reocgnized by system tools:

```bash
$ /usr/libexec/java_home -V

Matching Java Virtual Machines (1):
    23.0.1 (arm64) "Oracle Corporation" - "Java SE 23.0.1" /Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home
```

This repo has scripts to solve this for `asdf` and `sdkman`. After running them you should be able to see entries via the libexec tool. You likely should only run the one that is relevant to your setup.

```bash
$ /usr/libexec/java_home -V

Matching Java Virtual Machines (3):
    9999 (arm64) "SDKMAN" - "SDKMAN Current JDK" /Library/Java/JavaVirtualMachines/sdkman-java-current/Contents/Home
    23.0.1 (arm64) "openjdk" - "ASDF openjdk-23.0.1" /Library/Java/JavaVirtualMachines/asdf-java-23.0.1/Contents/Home
    23.0.1 (arm64) "Oracle Corporation" - "Java SE 23.0.1" /Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home
/Library/Java/JavaVirtualMachines/sdkman-java-current/Contents/Home
```

Inspired by this StackOverflow answer:



## Installing JDK via ASDF

```bash
brew install asdf
asdf plugin-add java
asdf list-all java
asdf install java openjdk-23.0.1
asdf global java openjdk-23.0.1

# See https://github.com/halcyon/asdf-java#java_home for setting JAVA_HOME
```


## Installing JDK via SDKMAN

```
brew tap sdkman/tap
brew install sdkman-cli

# Follow instructions to get SDKMAN script in your shell

sdk install java 23-open
```
