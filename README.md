# share_learning-api
API to get courses information from Coursera, Udacity and Youtube

## Routes
 * `/` - check if API alive
 * `v0.1/search/[search_keyword]` - search courses by keyword (e.g., machine learning)
 * `v0.1/overview` - get the number of courses from Coursera, Udacity. (Youtube will be set as 'inf' since there are too many contents)
