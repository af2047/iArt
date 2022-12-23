set -e

mode="${1:-test}"

case $mode in

  "test")
    python3 -m uvicorn main:app --host 127.0.0.1 --reload
    ;;

  "prod")
    python3 -m uvicorn main:app --host 0.0.0.0 
    ;;

  *)
    echo "Opciones válidas: 'test' y 'prod'."
    exit -1
    ;;

esac