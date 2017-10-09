# Localizations

In order to be better positioned for future expansion and international 
customers we want to ensure that our app is localized to the best of our 
ability. When developing you should always move any text into localizations as
you build so that we can ensure that our app is always able to be 
internationalized.

**Note** If someone mentions missing localizations on a PR they must be fixed.

### Gem audits

There is a development gem which will automatically audit missing translations.
This lets us find where we added translations quickly so we can get them 
translated asap.

https://github.com/glebm/i18n-tasks

Run the command by using
`i18n-tasks health`
