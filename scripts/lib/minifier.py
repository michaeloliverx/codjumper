def minify_source(source: str) -> str:
    i = 0
    length = len(source)
    result = ''

    while i < length:
        char = source[i]

        # strings first, nothing else matters inside a string
        if char == '"':
            start = i
            i += 1

            while i < length:
                end = source.find('"', i)

                # no closing quote, just copy the rest and return
                if end == -1:
                    result += source[start:]
                    return result

                # should only ever really be one backslash, but for safety here we are
                backslashes = 0
                j = (end - 1)

                while j >= start and source[j] == '\\':
                    backslashes += 1
                    j -= 1

                i = end + 1
                if backslashes % 2 == 0:
                    result += source[start:i]
                    break

            continue

        if char == '/':
            # single or multi-line?
            next = source[i + 1]
            if next == '/' or next == '*':
                close = '\n' if next == '/' else '*/'

                end = source.find(close, i)

                # comment is never closed, we reached the end
                if end == -1:
                    i = length
                    break

                i = end + (1 if close == '\n' else 2)
                continue

        if char.isspace():
            prev = source[i - 1]

            # no reason to have more than one space for any reason unless it's in a string
            while i < length and source[i].isspace():
                i += 1

            # the rest of the file is whitespace, nothing else to do
            if i == length:
                break

            # get next non-whitespace character
            next = source[i]

            if needs_space(prev, next):
                result += ' '

            continue

        # anything else
        result += char
        i += 1

    return result

def needs_space(prev: chr, next: chr) -> bool:
    operators = '+-*/%=&|^!<>'

    # don't combine operators in case it's something like a++ + b
    if prev in operators and next in operators:
        return True

    # handle cases where an array item might be trying to call something: (level.players[0] thread someFunction();)
    if prev == ']' and (next.isalnum() or next in '_['):
        return True

    return (prev.isalnum() or prev == '_') and (next.isalnum() or next == '_')
