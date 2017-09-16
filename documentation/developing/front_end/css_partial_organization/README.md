# Css and Partial Organization

Scheduleless uses very strict standards when it comes to organizing and naming
partials, css classes and filenames.

### CSS Organization


**Manifests:**
In the [Root Folder](/app/assets/stylesheets) we have 1 manifest per layout. This
manifest then requires all the files required under the folder with the same 
name. Hence `application.css.scss` loads all the files in the `application`
folder.

**Folder Structure:**
Inside the folder there are 4 other folders. Each of these folders contain
specific types of css with increasing specificity.

* Base - Includes styles that apply to the entire layout. This is typically 
  things like root elements like `<p>` and `<a>`.
* Mixins - Custom mixins to use
* Components - Includes pieces that are frequently used throughout the site.
  Editing these files should limit the scope of what is being edited to the
  component across the entire site.
* Views - View specific CSS that applies to only 1 partial. 

**View Specific CSS:**
We are destined to require specific css for certain views and layouts. While
we should try to lie on components and pre built layouts as much as possible,
it is okay to implement your own custom css code. I would rather duplicate then
force it into an ugly component.

The view specific code should be structured in the same way that the views
are structured.

`/app/views/users/edit.html.erb` becomes `/app/assets/stylesheets/application/views/users/edit.scss` 

In addition the class name needs to get standardized based on the path to. In
this example the class is `.users-edit`. It is the hyphenated path to that 
partial. 

Lastly if there is attached JS specific to this view it also needs to follow
the same folder/file convention.

This can lead to 3 files to define all the partial behavior.
`/app/views/users/edit.html.erb`
`/app/assets/stylesheets/application/views/users/edit.scss` 
`/app/assets/javascripts/application/views/users/edit.js`

If a partial is moved, the JS and Css files need moved and renamed as well.
**Keep the project organized**
