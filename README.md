# Atom Tab Limiter

![Atom Tab Limiter ](https://github.com/nju33/atom-tab-limiter/blob/master/screenshot.gif?raw=true)

## Install

```
apm install tab-limiter
```

## Usage

Don't have to do anything!  
If it exceeds the upper limit of the specified tab,
it will automatically close from the left tab. However, in the case of the following rule, it is passed through without being deleted.

- When editing a file
- When pinned is included in the tab (for [pinned-tab](https://atom.io/packages/pinned-tabs) package)

## Option

- `upperLimit`  
  default: `10`  
  Specify upper limit of tab
