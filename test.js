var injectr = require('./lib/injectr');

function test(file){
  injectr('test/'+file+'_tests.coffee');
}
if (process.argv[2])
  injectr(process.argv[2]);

else {
  test('myzappa');
  test('data');
}