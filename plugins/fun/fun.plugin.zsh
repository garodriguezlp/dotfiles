# Just to have some fun

# --- ------------------------------------------------------------------------------------------------
# --- Love
# --- ------------------------------------------------------------------------------------------------
function love() {
    echo "Getting you closer to your love... 🥰"
    echo "Opening web whatsapp for number: ${LOVE_NUMBER}"
    open "https://web.whatsapp.com/send/?phone=%2B57${LOVE_NUMBER}&text&type=phone_number&app_absent=0"
}
