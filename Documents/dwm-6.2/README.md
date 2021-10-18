## :bulb: FontAwsome

### How to install FontAwesome
- Download the zip containing all fonts from the [link](https://fontawesome.com/download).
- Extract all `otf's` files inside ~/.local/share/fonts/. If you don't have the folder, create it.
- Use the following command: ```fc-cache -f -v```

- on config.h overwrite the line:
  + ``` static const char *fonts[] = { "monospace:size=10" }; ```
- to
  + ``` static const char *fonts[] = { "monospace:size=10","fontawesome:size=10" }; ```


### Using it
- Choose a symbol [here](https://fontawesome.com/v5.15/icons?d=gallery&p=2&s=brands,solid&m=free).
- Copy ist unicode, or use directly with ctrl+c and ctrl+v.
