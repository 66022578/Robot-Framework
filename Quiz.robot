*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}             http://automationexercise.com
${FIRST_PRODUCT}   xpath=//div[@class="product-overlay"][1]//a[@data-product-id="1"]
${SECOND_PRODUCT}  xpath=//div[@class="product-overlay"][2]//a[@data-product-id="2"]
${VIEW_CART_BUTTON}    xpath=//a[contains(text(), "View Cart")]
${CART_ITEMS}          xpath=//table[@class="table table-condensed"]/tbody/tr
${PRODUCTS_LINK}       xpath=//a[contains(text(), "Products")]

*** Test Cases ***
Add Products in Cart
    [Documentation]    This test case verifies adding products to the cart, 
    ...                navigating through the pages, and verifying the cart's content.
    [Tags]    Cart, AddToCart
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    Set Browser Implicit Wait    10s  # Add implicit wait to handle dynamic elements
    Verify Home Page
    Go To Products Page
    Add First Product To Cart
    Continue Shopping
    Add Second Product To Cart
    Go To Cart
    Verify Products In Cart
    Close Browser

*** Keywords ***
Verify Home Page
    Title Should Be    Automation Exercise
    Page Should Contain Element    //div[@class='carousel-inner']

Go To Products Page
    Wait Until Element Is Visible    ${PRODUCTS_LINK}    timeout=10s  # Wait for the Products link to be visible
    Click Element    ${PRODUCTS_LINK}

Add First Product To Cart
    Wait Until Element Is Visible    ${FIRST_PRODUCT}    timeout=10s  # Wait for the product to be visible
    Mouse Over    xpath=//div[@class='product-image-wrapper'][1]
    Click Element    xpath=//a[@data-product-id='1']
    Wait Until Element Is Visible    //div[@class="modal-dialog"]
    Click Element    //button[text()='Add to cart']

Continue Shopping
    Wait Until Element Is Visible    //button[text()='Continue Shopping']    timeout=10s  # Ensure the Continue Shopping button is visible
    Click Element    //button[text()='Continue Shopping']
    Wait Until Page Contains    Products

Add Second Product To Cart
    Wait Until Element Is Visible    ${SECOND_PRODUCT}    timeout=10s  # Wait for the second product to be visible
    Hover Over Element    ${SECOND_PRODUCT}
    Click Element    ${SECOND_PRODUCT}
    Wait Until Element Is Visible    //div[@class="modal-dialog"]
    Click Element    //button[text()='Add to cart']

Go To Cart
    Wait Until Element Is Visible    ${VIEW_CART_BUTTON}    timeout=10s  # Wait for the "View Cart" button
    Click Element    ${VIEW_CART_BUTTON}
    Wait Until Element Is Visible    ${CART_ITEMS}    timeout=10s  # Ensure cart items are visible

Verify Products In Cart
    ${products}=    Get WebElements    ${CART_ITEMS}
    Length Should Be    2
    ${product1}=    Get Text    ${products[0]}
    ${product2}=    Get Text    ${products[1]}
    Should Contain    ${product1}    Product 1 Name
    Should Contain    ${product2}    Product 2 Name
    # Verify Prices, Quantity, and Total
    ${price1}=    Get Text    xpath=//table[@class="table table-condensed"]/tbody/tr[1]/td[3]
    ${price2}=    Get Text    xpath=//table[@class="table table-condensed"]/tbody/tr[2]/td[3]
    ${quantity1}=    Get Text    xpath=//table[@class="table table-condensed"]/tbody/tr[1]/td[5]
    ${quantity2}=    Get Text    xpath=//table[@class="table table-condensed"]/tbody/tr[2]/td[5]
    ${total_price}=    Get Text    xpath=//tfoot//tr[last()]/td[2]
    Should Be Equal As Numbers    ${total_price}    ${price1 + price2}
