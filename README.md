# share_learning-api
[ ![Codeship Status for BlueStarAshes/share_learning-api](https://app.codeship.com/projects/2375b400-8590-0134-0c4e-72b343bdcd56/status?branch=master)](https://app.codeship.com/projects/183373)     
API to get learning resource information from Coursera, Udacity and Youtube

## Routes
 * `/` - check if API alive
 * `v0.1/search/[search_keyword]` - search courses by keyword
   * e.g. "machine+learning".
   * Here "+" is used to represent the space in your keyword. So "machine+learning" would help you search resource related to "machine learning" on those platforms.
 * `v0.1/overview` - get the number of courses from Coursera, Udacity. (Youtube will be set as 'inf' since there are too many contents)

## Our current ER-model diagram
[ERD] <-- check it out here (draw.io)

![Imgur](http://i.imgur.com/6eYGuGL.png)

[ERD]:https://drive.google.com/file/d/0B58MTsVOT2bHbGNKdzVZdUdxdHc/view?usp=sharing
