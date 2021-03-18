# PHP_CodeSniffer code analysis

This action runs PHP static code analysis using PHP_CodeSniffer.

## Example usage

```yaml
uses: drugscom/phpcs-action@v1
with:
  args: --runtime-set 'ignore_warnings_on_exit' 'true'
```
