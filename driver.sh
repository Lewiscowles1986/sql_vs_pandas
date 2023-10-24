DIR=$1

rm -rf $DIR
mkdir -p $DIR

for n in {1000,10000,100000,1000000,10000000}; do
  echo $n >> "${DIR}/sqlite_load.txt"
  echo "sqlite loading ${n} records..."
  time ./driver/sqlite_load.sh "data/sample.${n}.csv" "data/bonus.${n}.csv" 2>> "${DIR}/sqlite_load.txt"

  for program in {"pandas","sqlite","memory-sqlite"}; do
    echo "running tests for ${n} records using ${program} driver..."
    for i in {1..10}; do
      python driver/driver.py $n "data/sample.${n}.csv" "data/bonus.${n}.csv" $program >> "${DIR}/driver.json"
    done
  done
done
