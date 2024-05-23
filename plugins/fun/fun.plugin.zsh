# Just to have some fun

# --- ------------------------------------------------------------------------------------------------
# --- Love
# --- ------------------------------------------------------------------------------------------------
function love() {
    echo "Getting you closer to your love... 🥰"
    echo "Opening web whatsapp for number: ${LOVE_NUMBER}"
    open "https://web.whatsapp.com/send/?phone=%2B57${LOVE_NUMBER}&text&type=phone_number&app_absent=0"
}

# --- ------------------------------------------------------------------------------------------------
# --- Love's pills reminder
# --- ------------------------------------------------------------------------------------------------
function pills() {
    echo "Sending pills reminder to your love... 💊"
    echo "Opening web whatsapp for number: ${LOVE_NUMBER}"
    open "https://web.whatsapp.com/send/?phone=%2B57${LOVE_NUMBER}&text=Baby%2C%20don%27t%20forget%20to%20take%20your%20pills.%20Love%20you%20so%20much%21&app_absent=0"
}
