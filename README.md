<p align="center"><a href="https://optidash.ai"><img src="media/logotype.png" alt="Optidash" width="143" height="45"/></a></p>

<p align="center">
Optidash is a modern, AI-powered image optimization and processing API.<br>We will drastically speed-up your websites and save you money on bandwidth and storage.
</p>

---
<p align="center">
<strong>The official Ruby integration for the Optidash API.</strong><br>
<br>
<img src="https://img.shields.io/gem/v/optidash?style=flat&color=success"/>
<img src="https://img.shields.io/snyk/vulnerabilities/github/optidash-ai/optidash-ruby?style=flat&color=success"/>
<img src="https://img.shields.io/github/issues-raw/optidash-ai/optidash-ruby?style=flat&color=success"/>
<img src="https://img.shields.io/github/license/optidash-ai/optidash-ruby?style=flat&color=success"/>
<img src="https://img.shields.io/twitter/follow/optidashAI?label=Follow%20Us&style=flat&color=success&logo=twitter"/>
</p>

---

### Documentation
See the [Optidash API docs](https://docs.optidash.ai/).

### Installation
```bash
$ gem install optidash
```

### Quick examples
Optidash API enables you to provide your images for optimization and processing in two ways - by uploading them directly to the API ([Image Upload](https://docs.optidash.ai/requests/image-upload)) or by providing a publicly available image URL ([Image Fetch](https://docs.optidash.ai/requests/image-fetch)).

You may also choose your preferred [response method](https://docs.optidash.ai/introduction#choosing-response-method-and-format) on a per-request basis. By default, the Optidash API will return a [JSON response](https://docs.optidash.ai/responses/json-response-format) with rich metadata pertaining to input and output images. Alternatively, you can use [binary responses](https://docs.optidash.ai/responses/binary-responses). When enabled, the API will respond with a full binary representation of the resulting (output) image. This Ruby integration exposes two convenience methods for interacting with binary responses: `.toFile()` and `.toBuffer()`.

#### Image upload
Here is a quick example of uploading a local file for processing. It calls `.toJSON()` at a final step and instructs the API to return a JSON response.

```ruby
require "optidash"

# Pass your Optidash API Key to the constructor
opti = Optidash.new("your-api-key")

# Upload an image from disk, resize it to 100 x 75,
# automatically enhance, and adjust sharpness parameter.
# You'll find the full JSON metadata within the `meta` variable
err, meta = (
    opti
        .upload("path/to/input.jpg")
        .optimize(
            compression: "medium"
        )
        .resize(
            width: 100,
            height: 75
        )
        .auto(
            enhance: true
        )
        .adjust(
            unsharp: 10
        )
        .to_json()
)

abort(err) if err
```

#### Image fetch
If you already have your source visuals publicly available online, we recommend using Image Fetch by default. That way you only have to send a JSON payload containing image URL and processing steps. This method is also much faster than uploading a full binary representation of the image.

```ruby
require "optidash"

# Pass your Optidash API Key to the constructor
opti = Optidash.new("your-api-key")

# Provide a publicly available image URL with `.fetch()` method,
# apply Gaussian blur using highly optimized PNG as the output format.
# We'll also use `.toFile()` method and stream the output image to disk
err, meta = (
    opti
        .fetch("https://www.website.com/image.jpg")
        .optimize(
            compression: "medium"
        )
        .filter(
            blur: (
                mode: "gaussian",
                value: 10
            }
        )
        .output(
            format: "png"
        )
        .to_file("path/to/output.png")
)

abort(err) if err
```

### License
This software is distributed under the MIT License. See the [LICENSE](LICENSE) file for more information.